require 'net/http'
class AiIndexingController < ApplicationController
	layout 'user_dashboard'
	before_action :authenticate_user!, :except => [:receive]
    before_filter :set_up_user, :except => [:receive]

    def receive

       hash_result = JSON.parse(params)
       video_data  = hash_result["data"]["video"]
       video_token = video_data["token"]
       # video_key =  video_data["key"]



      puts "***********************"
      puts "***********************"
      puts params.to_s
      puts "***********************"
      puts "***********************"


    uri = URI('https://videobreakdown.azure-api.net/Breakdowns/Api/Partner/Breakdowns?name=video1&privacy=Public')

    query = URI.encode_www_form({
        # Request parameters
        'videoUrl' => 'https://embed.ziggeo.com/v1/applications/8e270db9f0949e961323040b7f8e2cf1/videos/'+video_token+'/video.mp4'
    })



    # query = URI.encode_www_form({
    #     # Request parameters
    #     'videoUrl' => 'https://embed.ziggeo.com/v1/applications/8e270db9f0949e961323040b7f8e2cf1/videos/745961b32da37eb086e6dbe0f102d3e6/video.mp4',
    #     'language' => '',
    #     'externalId' => '',
    #     'metadata' => '',
    #     'description' => '',
    #     'partition' => '',
    #     'callbackUrl' => '',
    #     'indexingPreset' => '',
    #     'streamingPreset' => '',
    #     'linguisticModelId' => ''
    # })

    if uri.query && uri.query.length > 0
        uri.query += '&' + query
    else
        uri.query = query
    end

    request = Net::HTTP::Post.new(uri.request_uri)
    # Request headers
    request['Content-Type'] = 'multipart/form-data'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = '799bd7960a3249bb839b5c9f83ee6b67'
    # Request body
    request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end


    saved_result = Aivideo.new(token: response.body.to_s.tr('"', ''), description: "Video Interview Test")
    saved_result.save

    puts "*********************"
    puts response.body
    puts response
    puts "*********************"
    render plain: response.body, status: 200

    end


    def show_result
        @all_result = Aivideo.all
    end

    private
    
   # set current user and check if use has permissions to access the view
    def set_up_user
        # user's details
        @user = current_user
        @notification = Notification.where(user_id: @user.id, read: 0)
    end

end
