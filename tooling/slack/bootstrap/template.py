from pytest_bdd import scenario, given, when, then

@scenario('template.feature', 'Publishing the article')
def test_publish():
  pass


@given("I'm an author user")
def author_user(auth, author):
  auth['user'] = author.user


@given('I have an article')
def article(author):
  return create_test_article(author=author)


@when('I go to the article page')
def go_to_article(article, browser):
  browser.visit(urljoin(browser.url, '/manage/articles/{0}/'.format(article.id)))


@when('I press the publish button')
def publish_article(browser):
  browser.find_by_css('button[name=publish]').first.click()


@then('I should not see the error message')
def no_error_message(browser):
  with pytest.raises(ElementDoesNotExist):
    browser.find_by_css('.message.error').first


@then('the article should be published')
def article_is_published(article):
  article.refresh()  # Refresh the object in the SQLAlchemy session
  assert article.is_published