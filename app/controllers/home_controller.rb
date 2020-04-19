class HomeController < ApplicationController
  def index
    @result = search(search_params[:search])
  end

  private

  def search(term)
    return response_object(true, "", []) if term.blank?

    begin
      respons = github.search.repositories(q: term, auto_pagination: true)

      items = []
      respons.each_page do |page|
        page.items.each do |repo|
          items << (build_data_response repo)
        end
      end
      response_object(true, "", items)
    rescue => e
      response_object(false, e.message)
    end
  end

  def response_object(success, msg, data = [])
    OpenStruct.new(success: success, items: data.map { |item| build_data_response item }, error_msg: msg)
  end

  def build_data_response(repo)
    OpenStruct.new(
      full_name: repo.full_name,
      language: repo.language,
      url: repo.html_url,
      pushed_at: repo.pushed_at ? repo.pushed_at.to_s.to_date.strftime("%-d %b %Y") : "",
    )
  end

  # secrets should not be here
  def github
    @github ||= Github.new client_id: "625cacc10fce2ecfd5ad", client_secret: "d8a268c234d654576a65318b520e84324da6cb31"
  end

  def search_params
    params.permit(:search)
  end
end
