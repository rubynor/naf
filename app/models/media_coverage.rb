class MediaCoverage
  include Mongoid::Document
  field :subject_title, type: String
  field :media, type: String
  field :subject_link, type: String

  embedded_in :activity
  before_save :fix_link

  def fix_link
    return if self.subject_link.nil?
    if self.subject_link.blank?
       self.subject_link = nil
    elsif !self.subject_link.start_with?('http')
      self.subject_link = 'http://'+self.subject_link
    end
  end
end