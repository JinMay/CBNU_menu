require 'nokogiri'
require 'open-uri'
require 'json'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class NoticeController < ApplicationController
    def crawling
        Crj.delete_all
        Main.delete_all
        Yangjin.delete_all
        Yangsung.delete_all

        crj_url = 'http://www.cbhscrj.kr/food/list.do?menuKey=39'
        main_url = 'https://dorm.chungbuk.ac.kr/main/main.php'
        yangjin_url = 'https://dorm.chungbuk.ac.kr/main/main.php'
        yangsung_url = 'https://dorm.chungbuk.ac.kr/main/main.php'

        crj_data = Nokogiri::HTML(open(crj_url))
        main_data = Nokogiri::HTML(open(main_url))
        yangjin_data = Nokogiri::HTML(open(yangjin_url))
        yangsung_data = Nokogiri::HTML(open(yangsung_url))

        crj_menus = crj_data.css('div.food_week_box ul.on')
        main_menus = main_data.css('li#tab1c1 > ul.ul > li:nth-child(1)')
        yangsung_menus = yangsung_data.css('li#tab1c2 > ul.ul > li:nth-child(1)')
        yangjin_menus = yangjin_data.css('li#tab1c3 > ul.ul > li:nth-child(1)')


        Crj.create(
            :morning => crj_menus.css('li p')[0].text.gsub(',', "\n"),
            :lunch => crj_menus.css('li p')[1].text.gsub(',', "\n"),
            :dinner => crj_menus.css('li p')[2].text.gsub(',', "\n")
        )

        Main.create(
            :morning => main_menus.css('div.foodmenu1 li').to_s.gsub('<li>', '').gsub('</li>', "").gsub('amp;', '').gsub("\n", "").strip,
            :lunch => main_menus.css('div.foodmenu2 li').to_s.gsub('<li>', '').gsub('</li>', "").gsub('amp;', '').gsub("\n", "").strip,
            :dinner => main_menus.css('div.foodmenu3 li').to_s.gsub('<li>', '').gsub('</li>', "").gsub('amp;', '').gsub("\n", "").strip
        )

        Yangjin.create(
            :morning => yangjin_menus.css('div.foodmenu1 li').to_s.gsub('<li>', '').gsub('</li>', "").gsub('amp;', '').strip,
            :lunch => yangjin_menus.css('div.foodmenu2 li').to_s.gsub('<li>', '').gsub('</li>', "").gsub('amp;', '').strip,
            :dinner => yangjin_menus.css('div.foodmenu3 li').to_s.gsub('<li>', '').gsub('</li>', "").gsub('amp;', '').strip
        )

        Yangsung.create(
            :morning => yangsung_menus.css('div.foodmenu1 li').to_s.gsub('<li>', '').gsub('</li>', "").gsub('amp;', '').strip,
            :lunch => yangsung_menus.css('div.foodmenu2 li').to_s.gsub('<li>', '').gsub('</li>', "").gsub('amp;', '').strip,
            :dinner => yangsung_menus.css('div.foodmenu3 li').to_s.gsub('<li>', '').gsub('</li>', "").gsub('amp;', '').strip
        )

    end


    def show
        all = Main.all
        render json: all
    end


    def keyboard
        dorm_keyboard = {
            'type': 'buttons',
            'buttons': ['청람재', '본관', '양진재', '양성재']
        }

        render json: dorm_keyboard
    end


    def get_menu(dorm)
        if dorm == "청람재"
            menu = Crj.all[0]
        elsif dorm == "본관"
            menu = Main.all[0]
        elsif dorm == "양진재"
            menu = Yangjin.all[0]
        elsif dorm == "양성재"
            menu = Yangsung.all[0]
        end

        m = menu.morning
        l = menu.lunch
        d = menu.dinner

        return "[아침]\n#{m}\n\n[점심]\n#{l}\n\n[저녁]\n#{d}"
    end


    def answer
        raw_data = JSON.parse(request.raw_post)
        content = raw_data['content']

        answer_keyboard = {
                "message": {
                # "text": "오늘의 청람재 " + input_data + "식단 입니다"
                "text": "오늘의 " + content + "식단 입니다 \n\n" + get_menu(content)
            },
                "keyboard": {
                "type": "buttons",
                "buttons": ["청람재", "본관", "양진재", "양성재"],
            }
        }

        render json: answer_keyboard
    end


    def friend
        if request.method == 'POST'
            render status: 200
        elsif request.method == 'DELETE'
            render status: 200
        end
    end


    def chat_room
        if request.method == 'DELETE'
            render status: 200
        end
    end
end
