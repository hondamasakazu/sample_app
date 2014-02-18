class DocumentManagement < ActiveRecord::Base
  has_many :documents, dependent: :destroy
  default_scope -> { order('created_at DESC') }
  validates :name, presence: true

	def find_doc
		Document.where("document_management_id = ?", self.id)
	end

end
