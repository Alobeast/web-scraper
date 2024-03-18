class Page < ApplicationRecord
  has_many :results

  validates :url, presence: true
  validates :check_type, presence: true
  validates :selector, presence: true
  validates :match_text, presence: {if: :check_text?}

  def check_text?
    check_type == "text"
  end

  def run_check!
    scraper = Scraper.new(url)
    result  = case check_type
              when "text"
                scraper.text(selector: selector).downcase == match_text.downcase
              when "exists"
                scraper.present?(selector: selector)
              when "not_exists"
                !scraper.present?(selector: selector)
              end
    results.create(success: result)
end
