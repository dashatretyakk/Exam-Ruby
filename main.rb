class Email
  attr_accessor :subject, :sender, :receiver, :date, :tags, :category

  def initialize(subject, sender, receiver, date, tags, category)
    @subject = subject
    @sender = sender
    @receiver = receiver
    @date = date
    @tags = tags
    @category = category
  end
end

class Inbox
  attr_accessor :emails

  def initialize
    @emails = []
  end

  def add_email(email)
    emails << email
  end
end

class Sent
  attr_accessor :emails

  def initialize
    @emails = []
  end



  def add_email(email)
    emails << email
  end
end

class Spam
  attr_accessor :emails

  def initialize
    @emails = []
  end

  def add_email(email)
    emails << email
  end

  def auto_classify(email)
    # Автоматично класифікуємо лист як спам, якщо він від того ж відправника
    sender_emails = emails.select { |e| e.sender == email.sender }
    if sender_emails.length >= 3  # Змініть поріг за необхідності
      email.category = 'спам'
      add_email(email)
    end
  end
end

class EmailManager
  attr_accessor :inbox, :sent, :spam

  def initialize
    @inbox = Inbox.new
    @sent = Sent.new
    @spam = Spam.new
  end

  def add_email(email, category)
    case category
    when 'вхідні'
      inbox.add_email(email)
    when 'відправлені'
      sent.add_email(email)
    when 'спам'
      spam.add_email(email)
    else
      # Обробка користувацьких категорій
    end
  end

  def sort_by_date
    (inbox.emails + sent.emails + spam.emails).sort_by { |email| email.date }
  end

  def search_by_subject(keyword)
    (inbox.emails + sent.emails + spam.emails).select { |email| email.subject.include?(keyword) }
  end

  def search_by_tags(tags)
    (inbox.emails + sent.emails + spam.emails).select { |email| (email.tags & tags).any? }
  end

  def search_by_date_range(start_date, end_date)
    (inbox.emails + sent.emails + spam.emails).select { |email| email.date.between?(start_date, end_date) }
  end

  def search_by_sender(sender)
    (inbox.emails + sent.emails + spam.emails).select { |email| email.sender == sender }
  end

  def search_by_receiver(receiver)
    (inbox.emails + sent.emails + spam.emails).select { |email| email.receiver == receiver }
  end
end

# Виведення відсортованих листів за датою
puts "Сортування за датою:"
менеджер.sort_by_date.each { |email| puts "#{email.subject} - #{email.date}" }

# Пошук за тегами
puts "\nПошук за тегами:"
tag_search_result = менеджер.search_by_tags(["привітання"])
tag_search_result.each { |email| puts "#{email.subject} - #{email.tags}" }

# Пошук за діапазоном дати
puts "\nПошук за діапазоном дати:"
date_search_result = менеджер.search_by_date_range(Time.now - 86400, Time.now)
date_search_result.each { |email| puts "#{email.subject} - #{email.date}" }

# Пошук за відправником
puts "\nПошук за відправником:"
sender_search_result = менеджер.search_by_sender("користувач1")
sender_search_result.each { |email| puts "#{email.subject} - #{email.sender}" }
