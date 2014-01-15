module ApplicationHelper

	# ページごとの完全なタイトルを返します。
	def full_title(page_title)
	    base_title = "Network Solution Group"
	    if page_title.empty?
	    	base_title
	    else
	    	"#{base_title} | #{page_title}"
	    end
	end

  class HTMLwithCoderay < Redcarpet::Render::HTML
    def block_code(code, language)
      case language.to_s
      when 'rb'
        lang = 'ruby'
      when 'yml'
        lang = 'yaml'
      when ''
        # 空欄のままだと「Invalid id given:」エラー
        lang = 'md'
      else
        lang = language
      end

      CodeRay.scan(code, lang).div
    end
  end

  def markdown(text)
    html_render = HTMLwithCoderay.new(filter_html: true, hard_wrap: true)
    options = {
      autolink: true,
      space_after_headers: true,
      fenced_code_blocks: true,
    }
    markdown    = Redcarpet::Markdown.new(html_render, options)
    markdown.render(text)
  end

end
