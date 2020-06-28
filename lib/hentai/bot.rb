require "hentai/bot/version"
require 'telegram/bot'

module Hentai
  module Bot
    class Error < StandardError; end
    token = 'TOKEN'
    arr = IO.readlines("hentai.txt")

    def size
        return arr.size
    end

    def pick_random_line
        lines = File.readlines("hentai.txt")
        return lines[rand(lines.length)]
    end

    Telegram::Bot::Client.run(token) do |bot|
        bot.listen do |message|
            case message
            when Telegram::Bot::Types::CallbackQuery
                case message.data
                when '/info'
                    bot.api.send_message(chat_id: message.from.id, text: "Это бот с хентаем...")
                when '/hentai'
                    photo = pick_random_line
                    bot.api.send_photo(chat_id: message.from.id, photo: photo)
                    bot.api.send_message(chat_id: message.from.id, text: "Пропиши /hentai , что-бы получить ещё одну фотографию!")
                end
            when Telegram::Bot::Types::Message
                case message.text
                when '/start'
                    kb = [
                        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Хентай', callback_data: '/hentai'),
                        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Информация', callback_data: '/info'),
                    ]
                    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
                    bot.api.send_message(chat_id: message.chat.id, text: 'Выбирай', reply_markup: markup)
                when '/hentai'
                    photo = pick_random_line
                    bot.api.send_photo(chat_id: message.from.id, photo: photo)
                    kb = [
                        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Ещё', callback_data: '/hentai'),
                        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Информация', callback_data: '/info'),
                    ]
                    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
                    bot.api.send_message(chat_id: message.chat.id, text: 'Выбирай', reply_markup: markup)
                end
            end
        end
    end
  end
end
