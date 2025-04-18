from email import parser
from urllib.request import urlopen as uReq
from urllib.error import HTTPError
from bs4 import BeautifulSoup as soup
from mtgsdk import Card, Set
import argparse


def lookup_multiverse_id(multiverse_id):
    card_info = Card.find(multiverse_id)
    card_name = card_info.name
    set_name = card_info.set_name
    return card_name, set_name


def clean_input(card_name, set_name):
    bad_characters = {"'", ','}
    uncapitalized_words = {"Of", "For", "A", "The", "In", "An", "Vs"}
    #check if the bad characters are there and replace all of them
    for bad_character in card_name:
        if bad_character in bad_characters:
            card_name = card_name.replace(bad_character,"")
    for bad_character in set_name:
        if bad_character in bad_characters:
            set_name = set_name.replace(bad_character,"")
    card_name = card_name.title()
    set_name = set_name.title()
    def make_element_lowercase(list, word):
        word_index = list.index(word)
        list[word_index] = str.lower(list[word_index])
    card_name = card_name.split(" ")
    set_name = set_name.split(" ")
        #check and change the unimportant words to non-capitals
    i = 0
    for unapitalized_word in card_name:
        if unapitalized_word in uncapitalized_words and i != 0:
            make_element_lowercase(card_name, unapitalized_word)
        i += 1
    i = 0
    for uncapitalized_word in set_name:
        if unapitalized_word in uncapitalized_words and i != 0:
            make_element_lowercase(set_name, unapitalized_word)
        i += 1
    card_name = "+".join(card_name)
    set_name = "+".join(set_name)
    return card_name, set_name


def lookup_card_price(card_name, set_name, foil=False):
    card_name, set_name = clean_input(card_name, set_name)
    if foil == True:
        set_name = set_name + ":Foil"
    card_price_url = f"https://www.mtggoldfish.com/price/{set_name}/{card_name}#paper"
    try:
        uClient = uReq(card_price_url)
    except HTTPError:
        print("Please Enter a Valid Card and Set\nNames Must Match mtggoldfish.com's url")
        return("price not found")
    card_price_html = uClient.read()
    uClient.close()
    page_soup = soup(card_price_html, "html.parser")
    card_price_tag = page_soup.find("div",{"class":"price-box-price"})
    card_price_string = str(card_price_tag)
    #to index length of the value, find total length of string then - nonsense (37 characters)
    length_price = len(card_price_string) - 37
    card_price = "$" + card_price_string[31:31+length_price]
    return card_price
    

if __name__ == "__main__":
    def test_script(multiverse_id):
        card_name, set_name = lookup_multiverse_id(multiverse_id)
        card_price = lookup_card_price(card_name, set_name)
        print(card_name + " from " +set_name + " is " + card_price)

    parser = argparse.ArgumentParser(description='Stops the demo from starting.')
    parser.add_argument('--hush-demo', type=bool, default=False,
        help='A demo is inclded with a few cards test out the code. Use --hush-demo to skip this.')
    args = parser.parse_args()

    if args.hush_demo == False:
        multiverse_ids = [1135, 1, 2303, 74324, 525598, 10422]
        for multiverse_id in multiverse_ids:
            test_script(multiverse_id)

    user_input = input("Hi, Richard! Try Me! Enter a card and set number to see its price!\n(formated in card_name, set_name):\nType 'exit' to exit\n>")
    while user_input != "exit":
        if "," in user_input:
            card_name, set_name = user_input.split(", ")
            card_price = lookup_card_price(card_name, set_name)
            print(f"Your Card {card_name} from {set_name} is {card_price}")
            user_input = input("Enter another card, or type 'exit' to exit\n>")
        elif user_input == "exit":
            quit()
        else:
            print("Please Enter a card name AND set name separated by a comma, or type exit to exit")
            user_input = input(">")
