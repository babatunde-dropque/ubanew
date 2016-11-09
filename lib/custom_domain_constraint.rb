class CustomDomainConstraint
  def self.matches? request
    request.subdomain.present? && matching_organization?(request)
  end

  def self.matching_organization? request
    Company.where(:subdomain => request.subdomain).any?
  end
end