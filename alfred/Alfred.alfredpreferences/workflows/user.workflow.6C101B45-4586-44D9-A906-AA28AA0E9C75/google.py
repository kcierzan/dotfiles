#!/usr/bin/python
# encoding: utf-8

import sys

# Add lib directory to path
sys.path.insert(0, 'lib')

import argparse
import arrow
import httplib2
import os

from apiclient import discovery
from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage

SCOPES = 'https://www.googleapis.com/auth/calendar.readonly'
CLIENT_SECRET_FILE = 'google_client_id.json'
APPLICATION_NAME = 'AWeber Alfred Workflow'


def get_credentials():
    """Gets valid user credentials from storage.

    If nothing has been stored, or if the stored credentials are invalid,
    the OAuth2 flow is completed to obtain the new credentials.
    """
    home_dir = os.path.expanduser('~')
    credential_dir = os.path.join(home_dir, '.credentials')
    if not os.path.exists(credential_dir):
        os.makedirs(credential_dir)
    credential_path = os.path.join(
        credential_dir, 'alfred-workflow-credentials.json')

    store = Storage(credential_path)
    credentials = store.get()
    if not credentials or credentials.invalid:
        flow = client.flow_from_clientsecrets(CLIENT_SECRET_FILE, SCOPES)
        flow.user_agent = APPLICATION_NAME
        flags = argparse.Namespace(
            logging_level='DEBUG',
            auth_host_name='localhost',
            auth_host_port=[8080, 8090],
            auth_local_webserver=True,
            noauth_local_webserver=False,
        )
        credentials = tools.run_flow(flow, store, flags)
    return credentials


def find_vacation_calendar(calendars):
    for calendar in calendars:
        if calendar['summary'] == '--Vacations':
            return calendar['id']
    raise Exception('Calendar not found')


def format_event_date(event_date):
    return event_date.get('date', event_date.get('dateTime'))


def format_event(event):
    return dict(
        summary=event['summary'],
        start_date=format_event_date(event['start']),
        end_date=format_event_date(event['end']))


def get_vacation_events():
    credentials = get_credentials()
    http = credentials.authorize(httplib2.Http())
    service = discovery.build('calendar', 'v3', http=http)

    calendars = service.calendarList().list().execute().get('items', [])
    vacation_calendar_id = find_vacation_calendar(calendars)

    time_now = arrow.utcnow().to('local')
    start_date = time_now.replace(hour=0, minute=0, second=0, microsecond=0)
    end_date = time_now.replace(hour=23, minute=59, second=59, microsecond=0)

    result = service.events().list(
        calendarId=vacation_calendar_id,
        timeMin=start_date,
        timeMax=end_date,
        singleEvents=True).execute()
    return [format_event(event) for event in result.get('items', [])]
