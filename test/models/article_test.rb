require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @some_user = User.first
    @some_discipline = Discipline.first
  end

  test 'article creates' do
    article = Article.create title: 'My new article',
                             contents: 'Dummy text', author: @some_user,
                             discipline: @some_discipline
    assert article.save
    article.delete
  end

  test 'article requires title presence' do
    article = Article.create contents: 'Dummy text', author: @some_user,
                             discipline: @some_discipline
    assert_not article.valid?
  end

  test 'article doesnt require contents' do
    article = Article.create title: 'My new article',
                             author: @some_user,
                             discipline: @some_discipline
    assert article.valid?
  end

  test 'article doesnt require discipline' do
    article = Article.create title: 'My new article',
                             contents: 'Dummy text', author: @some_user
    assert article.valid?
  end

  test 'article requires author' do
    article = Article.create title: 'My new article',
                             contents: 'Dummy text',
                             discipline: @some_discipline
    assert_not article.valid?
  end

  test 'article limits title length to 128 symbols' do
    article = Article.create title: 'C' * 129,
                             contents: 'Dummy text', author: @some_user,
                             discipline: @some_discipline
    assert_not article.valid?
  end

  test 'article limits contents length to 1 kByte symbols' do
    article = Article.create title: 'My new article',
                             contents: 'D' * 1025, author: @some_user,
                             discipline: @some_discipline
    assert_not article.valid?
  end

  test 'article checks title uniqueness' do
    existing_article = Article.first
    article = Article.create title: existing_article.title,
                             contents: 'Dummy text', author: @some_user,
                             discipline: @some_discipline
    assert_not article.valid?
  end
end
