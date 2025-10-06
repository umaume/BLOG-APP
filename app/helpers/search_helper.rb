module SearchHelper
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
end
