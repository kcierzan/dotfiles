#!/usr/bin/python
# encoding: utf-8

import sys

# Add lib directory to path
sys.path.insert(0, 'lib')

import functools
import requests
from HTMLParser import HTMLParser


import google
from workflow import Workflow
from requests.auth import HTTPBasicAuth
from subprocess import Popen, PIPE

JENKINS_URL = ('{}/api/json?tree=jobs[name,url,lastBuild[timestamp]]'
               '&pretty=true')
JENKINS_SERVERS = {
    'colo': 'http://jenkins.colo.lair:8080/',
    'webapp': 'http://jenkins-webapp.svc.prd.csh/',
    'docker': 'http://jenkins-docker.svc.csh/',
}

GRAFANA_URI = 'http://grafana.colo.lair/api/search?query='
DOCS_URI = 'http://docs.int.prd.csh/docs/'
HIPCHAT_URI = ('https://api.hipchat.com/v2/{resource}?auth_token={token}'
               '&max-results=1000')


class Result(object):
    def __init__(self, title, subtitle=None, arg=None):
        self.title = title.decode('utf-8')
        self.subtitle = subtitle or self.title
        self.arg = arg or self.title


def _fetch_jenkins(wf):
    jobs = []
    for name, hostname in JENKINS_SERVERS.items():
        user = wf.settings.get('jenkins_{}'.format(name))
        if not user:
            continue
        pwd = wf.get_password('jenkins_{}'.format(name))
        auth = HTTPBasicAuth(user, pwd)
        jobs.extend(requests.get(
            JENKINS_URL.format(hostname), auth=auth).json().get('jobs'))

    def _sort(x):
        if x.get('lastBuild'):
            return int(x.get('lastBuild').get('timestamp'))
        return 0
    jobs.sort(key=_sort, reverse=True)
    return [Result(title=job['name'], subtitle=job['url'], arg=job['url'])
            for job in jobs]


def _fetch_github(wf):
    process = Popen('./get-github-repositories.sh', stdout=PIPE)
    stdout, stderr = process.communicate()
    return [Result(title=repo) for repo in stdout.split('\n')]


def _fetch_gitlab(wf):
    process = Popen('./get-gitlab-repositories.sh', stdout=PIPE)
    stdout, stderr = process.communicate()
    return [Result(title=repo) for repo in stdout.split('\n')]


def _fetch_servers(wf):
    process = Popen('./get-servers.sh', stdout=PIPE)
    stdout, stderr = process.communicate()
    return [Result(title=repo) for repo in stdout.split('\n')]


def _fetch_grafana(wf):
    dashboards = requests.get(GRAFANA_URI).json()
    return [Result(title=dashboard['uri']) for dashboard in dashboards]


class BasicHTMLParser(HTMLParser):
    links = set()

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            href = attrs[0][1]
            if not href.startswith('/') and href.endswith('/'):
                self.links.add(href.strip('/'))


def _fetch_docs(wf):
    links = requests.get(DOCS_URI).text
    parser = BasicHTMLParser()
    parser.feed(links)
    return [Result(title=link) for link in parser.links]


def _fetch_hipchat(wf):
    token = wf.get_password('hipchat')
    rooms = requests.get(
        HIPCHAT_URI.format(resource='room', token=token)).json()
    users = requests.get(
        HIPCHAT_URI.format(resource='user', token=token)).json()
    results = []
    for type, records in [('room', rooms), ('user', users)]:
        for record in records['items']:
            results.append(Result(title=record['name'], subtitle=type,
                                  arg='{}/{}'.format(type, record['id'])))
    return results


def _fetch_pto(wf):
    events = google.get_vacation_events()
    return [Result(title=event['summary'],
                   subtitle='From {} to {}'.format(
                       event['start_date'], event['end_date']))
            for event in events]


def _fetch_services(wf):
    services = google.get_services()
    return [Result(title=service['name'],
                   arg='{}'.format(service['rownum']),
                   subtitle='Team: {} - Description: {}'.format(
                       service['team'], service['description']))
            for service in services]


def search(operation, wf, args):
    query = args[0] if args else ''
    func = FETCH_OPERATIONS.get(operation)
    get_jobs = functools.partial(func, wf=wf)
    results = wf.cached_data(operation, get_jobs, max_age=3600)
    if query:
        results = wf.filter(query, results, key=lambda x: x.title)
    for r in results:
        icon = '{}.png'.format(operation)
        wf.add_item(r.title, r.subtitle, arg=r.arg, valid=True, icon=icon)
    wf.send_feedback()


def set_credentials(wf, args):
    service, user, token = args
    wf.settings[service] = user
    wf.save_password(service, token)


def main(wf):
    args = wf.args or ['']
    operation = args.pop(0)
    if operation in FETCH_OPERATIONS.keys():
        search(operation, wf, args)
    if operation == 'creds' and len(args) == 3:
        set_credentials(wf, args)


FETCH_OPERATIONS = {
    'github': _fetch_github,
    'gitlab': _fetch_gitlab,
    'jenkins': _fetch_jenkins,
    'grafana': _fetch_grafana,
    'docs': _fetch_docs,
    'hipchat': _fetch_hipchat,
    'pto': _fetch_pto,
    'services': _fetch_services,
    'servers': _fetch_servers,
}

if __name__ == '__main__':
    wf = Workflow()
    sys.exit(wf.run(main))
