Rails.application.routes.draw do
    get 'crawling' => 'notice#crawling'

    get 'keyboard' => 'notice#keyboard'
    post 'message' => 'notice#answer'
    post 'friend' => 'notice#friend'
    delete 'friend/:user_key' => 'notice#friend'
    delete 'chat_room/:user_key' => 'notice#chat_room'
end
