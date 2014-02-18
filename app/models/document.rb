class Document < ActiveRecord::Base
	belongs_to :document_management
  default_scope -> { order('created_at DESC') }
  validates :file_name, presence: true

  MAX_FILE_SIZE = 10000000

  def doc_save_valid?(file)
    return "ドキュメントが選択されていません" if file.blank?
    return "アップロード可能なファイルサイズは10MBまでです。" if file[:doc].size > MAX_FILE_SIZE
  end

  def doc_save(file)

    file_name = file.original_filename;
    self.file_name = file_name
    return false unless self.save

    # 一時的に、tmpへファイル出力
    file_path = create_tmp_file_path(file)
	  create_tmp_file(file_path, file)

	  # S3へファイルアップロード
		s3_file_path = s3_file_upload(file_path)

    # ファイルパスの更新
		update_file_path(s3_file_path)

    # 一時ファイル削除
    File.unlink file_path
  end

  private
  	def create_tmp_file(file_path, file)
		  File.open(file_path, 'wb') do |of|
		    of.write(file.read)
		  end
  	end

    def create_tmp_file_path(file)
      time_str = get_now_time_str
      tmp_file_path = "#{Rails.root}/tmp/uploads/#{time_str}"
      mkdir_tmp(tmp_file_path)
      "#{tmp_file_path}/#{file.original_filename}"
    end

  	def s3_file_upload(file_path)
			s3 = AWS::S3.new(
			  :access_key_id     => 'AKIAJIMRA7H56PP7F7UQ',
			  :secret_access_key => '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',
			  :s3_endpoint       => 's3-ap-northeast-1.amazonaws.com')

			bucket = s3.buckets['future-commynity']
      time_str = get_now_time_str
			s3_file_path_tmp = "#{time_str}/#{self.id}/#{File.basename(file_path)}"
			o = bucket.objects[s3_file_path_tmp]
			o.write(:file => file_path, :acl => :public_read)
      s3_file_path_tmp
  	end

  	def update_file_path(s3_file_path)
			s3_file_path = "http://future-commynity.s3-ap-northeast-1.amazonaws.com/#{s3_file_path}"
	    self.update_attributes(:file_path => s3_file_path)
  	end

    def get_now_time_str
      Time.now.instance_eval { '%s%03d' % [strftime('%Y%m%d%H%M%S'), (usec / 1000.0).round] }
    end

    def mkdir_tmp(path)
      FileUtils.mkdir_p(path) unless FileTest.exist?(path)
    end

end
