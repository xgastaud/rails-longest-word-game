require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @rand_array=[]
    alphabet = ("A".."Z").to_a
    10.times do
      @rand_array << alphabet.sample
    end
  end

  def score
    session[:total_score] = 0
    @score = 0
    @word = params[:word].upcase
    @rand_array = params[:rand_array]
    @word.split("").each do |letter|
      if @rand_array.include?(letter)
      # if word can't be built out of original grid
        url_result = "https://wagon-dictionary.herokuapp.com/#{@word}"
        serialized_results = open(url_result).read
        results = JSON.parse(serialized_results)
        if results["found"] == true
          # if word is a valid English word, increment score
          @score = @word.length
          @message = "Good answer!"
          session[:total_score] += @score
        end
      else
        @message = "invalid answer!"
      end
    end
    @total = session[:total_score]
  end
end
