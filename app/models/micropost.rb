require 'aws-sdk'

class Micropost < ActiveRecord::Base
	belongs_to :user
	belongs_to :group
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  MAX_FILE_SIZE = 10000000

  def post_save
    self.doc_flg = false;
    self.save
  end

  def doc_save_valid?(file)
    return "ドキュメントが選択されていません" if file.blank?
    return "アップロード可能なファイルサイズは10MBまでです。" if file.size < MAX_FILE_SIZE
  end

  def doc_save(file)

    file_name = file.original_filename;
    self.file_name = file_name
    self.doc_flg = true;
    self.content = "document Upoud data"
    return false unless self.save

    # 一時的に、tmpへファイル出力
    tmp_file_path = "#{Rails.root}/tmp/uploads/" + file_name
	  create_tmp_file(tmp_file_path, file)

	  # S3へファイルアップロード
		s3_objects = s3_file_upload(tmp_file_path)

    # ファイルパスの更新
		update_file_path(s3_objects)

    # 一時ファイル削除
     File.unlink tmp_file_path
  end

  private
  	def create_tmp_file(tmp_file_path, file)
		  File.open(tmp_file_path, 'wb') do |of|
		    of.write(file.read)
		  end
  	end

  	def s3_file_upload(tmp_file_path)
			s3 = AWS::S3.new(
			  :access_key_id     => 'AKIAJIMRA7H56PP7F7UQ',
			  :secret_access_key => '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',
			  :s3_endpoint       => 's3-ap-northeast-1.amazonaws.com')

			micropost = Micropost.find(self.id)
			bucket = s3.buckets['future-commynity']
			s3_file_path_tmp = "#{micropost.id}/#{File.basename(tmp_file_path)}"
			o = bucket.objects[s3_file_path_tmp]
			o.write(:file => tmp_file_path, :acl => :public_read)
  	end

  	def update_file_path(s3_objects)
			micropost = Micropost.find(self.id)
			s3_file_path = "http://future-commynity.s3-ap-northeast-1.amazonaws.com/#{s3_objects.key}"
	    micropost.update_attributes(:file_path => s3_file_path)
  	end

end
