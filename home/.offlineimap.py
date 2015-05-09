import os

def get_login_info(key='www/webmail.draco.uberspace.de'):
  cmd = "pass %s" % key
  p = os.popen(cmd)
  password = p.readline().strip()
  assert password, 'no password'
  key, user = p.readline().split(':')
  assert key == 'user'
  return user.strip(), password

def get_imap_password():
    user, password = get_login_info()
    return password

def get_imap_user():
    user, password = get_login_info()
    return user
