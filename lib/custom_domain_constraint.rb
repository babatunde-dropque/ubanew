class CustomDomainConstraint
  def self.matches? request
    request.subdomain.present? && matching_organization?(request)
  end

  def self.matching_organization? request
    Company.find_by(:subdomain => request.subdomain)
  end
end