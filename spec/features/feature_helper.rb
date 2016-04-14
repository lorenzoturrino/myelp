DEFAULT_MAIL = "m@m.com"
DEFAULT_PASSWORD = "1234verysecure"

def helper_signup(email=DEFAULT_MAIL, password=DEFAULT_PASSWORD)
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: email)
  fill_in('Password', with: password)
  fill_in('Password confirmation', with: password)
  click_button('Sign up')
end
