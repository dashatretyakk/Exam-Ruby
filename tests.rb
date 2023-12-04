require 'minitest/autorun'

class EmailTest < Minitest::Test
  def test_email_initialization
    email = Email.new('Test Subject', 'sender@example.com', 'receiver@example.com', Time.now, ['tag1', 'tag2'], 'important')

    assert_equal 'Test Subject', email.subject
    assert_equal 'sender@example.com', email.sender
    assert_equal 'receiver@example.com', email.receiver
    assert_instance_of Time, email.date
    assert_equal ['tag1', 'tag2'], email.tags
    assert_equal 'important', email.category
  end
end

class InboxTest < Minitest::Test
  def test_inbox_creation
    inbox = Inbox.new
    assert_instance_of Inbox, inbox
    assert_equal [], inbox.emails
  end

  def test_add_email_to_inbox
    inbox = Inbox.new
    email = Email.new('Test Subject', 'sender@example.com', 'receiver@example.com', Time.now, ['tag1', 'tag2'], 'important')

    inbox.add_email(email)
    assert_equal 1, inbox.emails.length
    assert_equal email, inbox.emails.first
  end
end

class SentTest < Minitest::Test
  def test_sent_creation
    sent = Sent.new
    assert_instance_of Sent, sent
    assert_equal [], sent.emails
  end

  def test_add_email_to_sent
    sent = Sent.new
    email = Email.new('Test Subject', 'sender@example.com', 'receiver@example.com', Time.now, ['tag1', 'tag2'], 'important')

    sent.add_email(email)
    assert_equal 1, sent.emails.length
    assert_equal email, sent.emails.first
  end
end

class SpamTest < Minitest::Test
  def test_spam_creation
    spam = Spam.new
    assert_instance_of Spam, spam
    assert_equal [], spam.emails
  end

  def test_add_email_to_spam
    spam = Spam.new
    email = Email.new('Test Subject', 'sender@example.com', 'receiver@example.com', Time.now, ['tag1', 'tag2'], 'important')

    spam.add_email(email)
    assert_equal 1, spam.emails.length
    assert_equal email, spam.emails.first
  end

  def test_auto_classify_as_spam
    sender = 'spam_sender@example.com'
    spam = Spam.new

    4.times do
      email = Email.new('Important Offer', sender, 'receiver@example.com', Time.now, ['spam'], 'important')
      spam.add_email(email)
    end


    assert_equal 1, spam.emails.length
    assert_equal 'Important Offer', spam.emails.first.subject
  end
end

class EmailManagerTest < Minitest::Test
  def test_email_manager_creation
    email_manager = EmailManager.new
    assert_instance_of EmailManager, email_manager
    assert_instance_of Inbox, email_manager.inbox
    assert_instance_of Sent, email_manager.sent
    assert_instance_of Spam, email_manager.spam
  end
  def test_add_email_to_inbox_via_email_manager
    email_manager = EmailManager.new
    email = Email.new('Test Subject', 'sender@example.com', 'receiver@example.com', Time.now, ['tag1', 'tag2'], 'important')

    email_manager.add_email(email, 'вхідні')
    assert_equal 1, email_manager.inbox.emails.length
    assert_equal email, email_manager.inbox.emails.first
  end

  def test_sort_by_date
    email_manager = EmailManager.new
    email1 = Email.new('Test Subject 1', 'sender@example.com', 'receiver@example.com', Time.now, ['tag1', 'tag2'], 'important')
    email2 = Email.new('Test Subject 2', 'sender@example.com', 'receiver@example.com', Time.now - 3600, ['tag1', 'tag2'], 'important')

    email_manager.add_email(email1, 'вхідні')
    email_manager.add_email(email2, 'вхідні')

    sorted_emails = email_manager.sort_by_date
    assert_equal 2, sorted_emails.length
    assert_equal 'Test Subject 2', sorted_emails.first.subject
    assert_equal 'Test Subject 1', sorted_emails.last.subject
  end


end


