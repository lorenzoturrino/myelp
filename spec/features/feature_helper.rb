DEFAULT_MAIL = 'lo@renzo.com'
DEFAULT_PASSWORD = 'lolsrenzo'

def helper_signup(email: DEFAULT_MAIL, password: DEFAULT_PASSWORD)
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: email)
  fill_in('Password', with: password)
  fill_in('Password confirmation', with: password)
  click_button('Sign up')
end

def helper_signin(email: DEFAULT_MAIL, password: DEFAULT_PASSWORD)
  visit('/')
  click_link('Sign in')
  fill_in('Email', with: email)
  fill_in('Password', with: password)
  click_button('Log in')
end
