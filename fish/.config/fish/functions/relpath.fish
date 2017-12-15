function relpath
  python -c "import os.path; print os.path.relpath('$argv[1]', '$argv[2]')"
end
