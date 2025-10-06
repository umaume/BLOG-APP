module ApplicationHelper
  include BreadcrumbsHelper

  def time_ago_in_japanese(time)
    # 確実に日本語ロケールを使用
    I18n.with_locale(:ja) do
      "#{time_ago_in_words(time)}前"
    end
  end

  def published_time_in_japanese(time)
    I18n.with_locale(:ja) do
      "公開 #{time_ago_in_words(time)}前"
    end
  end

  def joined_date_in_japanese(time)
    I18n.with_locale(:ja) do
      "参加 #{l(time, format: :default)}"
    end
  end

  # より詳細な時間表示用のメソッドを追加
  def format_japanese_datetime(time)
    I18n.with_locale(:ja) do
      l(time, format: :default)
    end
  end

  def format_japanese_date(time)
    I18n.with_locale(:ja) do
      l(time.to_date, format: :default)
    end
  end

  # 検索ハイライト機能
  def highlight_search_terms(text, search_query)
    return text if search_query.blank?

    highlighted = text
    search_query.split(/\s+/).each do |term|
      highlighted = highlighted.gsub(/(#{Regexp.escape(term)})/i, '<mark class="bg-yellow-200">\1</mark>')
    end
    highlighted.html_safe
  end

  def truncate_with_highlight(text, length, search_query = nil)
    truncated = truncate(text, length: length, separator: ' ')
    search_query.present? ? highlight_search_terms(truncated, search_query) : truncated
  end

  # URL安全性チェック用メソッド
  def sanitize_url(url)
    return nil if url.blank?
    
    # URLの形式をチェックし、安全でないスキームを除外
    begin
      uri = URI.parse(url)
      return nil unless %w[http https].include?(uri.scheme&.downcase)
      url
    rescue URI::InvalidURIError
      nil
    end
  end
end
