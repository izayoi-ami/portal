class DisciplineController < ApplicationController
  def index
  end

  def letter
    if letter_params.has_key?(:late)
        require "roo"
        require "spreadsheet"

        criteria=[[3,"1WL"],[5,"1D"],[8,"2WL"],[12,"LD3"],[15,"LD5"]]

        file=letter_params[:late]
        csvPath="#{Rails.root}/tmp/lateness.csv"
        `xls2csv #{file.path} >#{csvPath}`
        csv=Roo::Spreadsheet.open(csvPath)
        csv_output="#{Rails.root}/tmp/letter.csv"
        CSV.open(csv_output,"wb") do |f|
            f<<["class","no","ename","totlate","newlate","oldlate","Action"]
            csv.each_with_index(:cls=>"class",:ename=>"ename",:no=>"no",:tlate=>"totlate",:lastlate=>"late to"){ |s,index|
                next if index==0
                p s
                t=criteria.select{ |a,b| a.between?(s[:lastlate].to_i+1,s[:tlate].to_i)}.map{|a,b| b}.join(" ")
                f<<[s[:cls],s[:no],s[:ename],s[:tlate],s[:tlate].to_i - s[:lastlate].to_i,s[:lastlate],t] if t!=""
            }
        end
        send_file(csv_output)
    end
  end

  private

  def letter_params
    params.permit(:late)
  end


end
