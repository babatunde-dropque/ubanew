class FiltersController < ApplicationController

  def all
  if (params[:status].to_i == 4)
    @status_all = nil
  else
    @status_all = params[:status].to_i
  end
  @company = Company.find(params[:id])
    @interviews = @company.interviews.includes(:users).where(submissions: {status: @status_all}).paginate(:page => params[:page], :per_page => 5)
	respond_to do |format|
		format.html {render partial: 'companies/all'}
	end	
  end

  def jobfilter
    if (params[:status].to_i == 4)
      @status = nil
    else
      @status = params[:status].to_i
    end
  	@company = Company.find(params[:id])
  	@interviews = @company.interviews.includes(:users).where(submissions: {status: @status}, id:params[:job_id]).paginate(:page => params[:page], :per_page => 5)

    respond_to do |format|
      format.html {render partial: 'companies/all'}

  	end
  end

  def search

  end
end




# class FilterController < ApplicationController
#     def all
#       if (params[:status].to_i ==4)
#          @status_all = nil
#         else @status_all = params[:status].to_i
#         end
#         @company = Company.find(params[:id])
#         @jobs = @company.jobs.includes(:users).where(submissions: {status:@status.all}).paginate(:page=>params[:page], :per_page=>5)
#         respond_to do |format|
#           format.html{render partial: 'companies/all'}
#       end
#    end



#    def jobfilter
#     if (params[:status].to_i==4)
#       @status = nil
#     else
#       @status = params[:status].to_i
#     end
#     @company = Company.find(params[:id])
#     @jobs = company.jobs.includes(:users).where(submissions:{status:@status}, id:params[:job_id]).paginate(:page=>params[:page], :per_page=>5)
#     respond_to do |format|
#       format.html{render partial: 'company/all'}
#     end
#   end 

#   def search
#   end 





# end




