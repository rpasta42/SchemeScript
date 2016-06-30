#!/usr/bin/python

#pip install pyinotify

import time, sys, pyinotify, subprocess

debug = False

if len(sys.argv) != 2:
   if len(sys.argv) == 3 and sys.argv[2] == '-d':
      debug = True
   else:
      print('%s <PATH_TO_MONITOR> [-d]' % sys.argv[0])
      exit()

path = sys.argv[1]

wm = pyinotify.WatchManager()
notifier = pyinotify.Notifier(wm)

def on_event(arg):
   name = arg.pathname
   #print('event %s' % name)
   ext = name.split('.')[-1]
   if ext == 'ss' or ext == 'scm':
      if debug:
         print('scheme/sscript file changed: %s' % name)
      subprocess.call(['./deploy.sh'])
      #subprocess.call(['pkill', 'gunicorn'])

#watch_mask = pyinotify.ALL_EVENTS
watch_mask = pyinotify.IN_CREATE | pyinotify.IN_MODIFY
#exclude_filter=not_py_file (this can be used to exclude .git directory)
wm.add_watch(path, watch_mask, proc_fun=on_event, rec=True, auto_add=True, quiet=False)

notifier.loop()

