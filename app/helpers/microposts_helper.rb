module MicropostsHelper

  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  def this_group_name(group_id)
    group_id.blank? ? "may Acount": get_group_name(group_id)
  end

  private

    def get_group_name(group_id)
      name = Group.find(group_id).name
      "#{name} Group よりツイート!"
    end

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text :
                                  text.scan(regex).join(zero_width_space)
    end
end