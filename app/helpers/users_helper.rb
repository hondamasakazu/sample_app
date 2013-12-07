module UsersHelper

	def gravatar_for(user, opsions = { size: 50 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = opsions[:size]
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar" )
	end

end
