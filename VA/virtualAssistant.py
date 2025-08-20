# 2025-5-29
# virtualAssistant.py
# Farah Noor
# Virtual Assistant
# Purpose: A fun virtual assistant that allows the user to search Google and play a variety of games

import webbrowser
import random
import pygame
import os
from PIL import Image


# Create a robot GIF
def robot_image():
    file = ['robotgif1.png', 'robotgif2.png']
    images = []
    first_image = Image.open(file[0])
    images.append(first_image)
    fixed_size = first_image.size
    for filename in file[1:]:
        img = Image.open(filename)
        img = img.resize(fixed_size)
        images.append(img)
    # Save the GIF
    gif_path = "team.gif"
    (images[0].save(
        gif_path,
        save_all=True,
        append_images=images[1:],
        duration=500,
        loop=0
    ))
    # this line only works for Windows
    os.startfile(gif_path)


# Greet the user
def greet_user():
    name = input("Hi! What's your name? ")
    print(f"Hello, {name}! Nice to meet you. 😄")
    return name


# Search Google
def repeat_question():
    search = input("What would you like to search? ")
    query = search.replace(" ", "+")
    print("Opening Google to find the answer... 🌐")
    webbrowser.open(f"https://www.google.com/search?q={query}")


def search_google():
    repeat_question()
    while True:
        another = input("Would you like to search again? (yes/no) ")
        if another == "no":
            break
        else:
            repeat_question()


# Games
def play_guess_number():
    print("\nLet's play Guess the Number! ")
    number = random.randint(1, 20)
    print("I am thinking of a number between 1 and 20. Can you guess it? ")
    attempts = 0
    while True:
        try:
            guess = int(input("Your guess: "))
        except ValueError:
            print("Please enter a valid number. ")
            continue
        attempts += 1
        if guess < number:
            print("Too low! ")
        elif guess > number:
            print("Too high! ")
        else:
            print(f" Correct! You guessed it in {attempts} tries.")
            break


def play_rps():
    print("\nLet's play Rock-Paper-Scissors! ✊✋✌️")
    options = ["rock", "paper", "scissors"]
    assistant = random.choice(options)
    user = input("Choose rock, paper, or scissors: ").lower()
    print(f"I chose: {assistant}")
    if user == assistant:
        print("It's a tie! ")
    elif (user == "rock" and assistant == "scissors") or \
            (user == "paper" and assistant == "rock") or \
            (user == "scissors" and assistant == "paper"):
        print("You win! 🏆")
    else:
        print("You lose! ")


def play_word_scramble():
    print("\nLet's play Word Scramble! ")
    with open("words.txt", "r") as w:
        words = [line.strip() for line in w if line.strip()]
    word = random.choice(words)
    scrambled = ''.join(random.sample(word, len(word)))
    print(f"Unscramble this word: {scrambled}")
    guess = input("Your guess: ").lower()
    if guess == word:
        print(" Correct! Well done.")
    else:
        print(f" Not quite! The correct word was '{word}'.")


def play_ball():
    WIDTH, HEIGHT = 600, 400
    WHITE = (255, 255, 255)
    BLUE = (50, 50, 255)
    RED = (255, 0, 0)
    BLACK = (0, 0, 0)
    basket_width, basket_height = 100, 20
    pygame.init()
    screen = pygame.display.set_mode((WIDTH, HEIGHT))
    pygame.display.set_caption("Catch the Ball ")
    basket = pygame.Rect(WIDTH // 2 - basket_width // 2, HEIGHT - 40, basket_width, basket_height)
    # Ball
    ball_size = 20
    ball = pygame.Rect(random.randint(0, WIDTH - ball_size), 0, ball_size, ball_size)
    ball_speed = 5
    # Score & Lives
    score = 0
    lives = 3
    font = pygame.font.SysFont(None, 36)
    # Game loop
    running = True
    game_over = False
    clock = pygame.time.Clock()
    while running:
        # Events
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
        if not game_over:
            # Controls
            keys = pygame.key.get_pressed()
            if keys[pygame.K_LEFT] and basket.left > 0:
                basket.move_ip(-7, 0)
            if keys[pygame.K_RIGHT] and basket.right < WIDTH:
                basket.move_ip(7, 0)
            # Move ball
            ball.move_ip(0, ball_speed)
            # If ball hits bottom
            if ball.top > HEIGHT:
                ball = pygame.Rect(random.randint(0, WIDTH - ball_size), 0, ball_size, ball_size)
                lives -= 1  # lose a life if missed
                if lives == 0:
                    game_over = True
            # If basket catches ball
            if basket.colliderect(ball):
                score += 1
                ball = pygame.Rect(random.randint(0, WIDTH - ball_size), 0, ball_size, ball_size)
            # Drawing
            screen.fill(WHITE)
            pygame.draw.rect(screen, BLUE, basket)  # Basket
            pygame.draw.ellipse(screen, RED, ball)  # Ball
            # Draw score & lives
            text = font.render(f"Score: {score}", True, BLACK)
            lives_text = font.render(f"Lives: {lives}", True, BLACK)
            screen.blit(text, (10, 10))
            screen.blit(lives_text, (WIDTH - 120, 10))
        else:
            # Game Over Screen
            screen.fill(WHITE)
            over_text = font.render("GAME OVER ", True, RED)
            score_text = font.render(f"Final Score: {score}", True, BLACK)
            screen.blit(over_text, (WIDTH // 2 - 100, HEIGHT // 2 - 40))
            screen.blit(score_text, (WIDTH // 2 - 100, HEIGHT // 2 + 10))
        pygame.display.flip()
        clock.tick(60)
    pygame.quit()


def play_game():
    print("\nWhich game would you like to play?")
    print("1. Guess the Number")
    print("2. Rock-Paper-Scissors")
    print("3. Word Scramble")
    print("4. Catch the Ball")
    choice = input("Enter 1, 2, 3, or 4: ")
    if choice == "1":
        play_guess_number()
    elif choice == "2":
        play_rps()
    elif choice == "3":
        play_word_scramble()
    elif choice == "4":
        play_ball()
    else:
        print("Invalid choice. Going back to main menu. ")


# Chat with assistant
def story():
    print("🌟 Welcome to my story... 🌟")
    print("Do you want to hear how I came to be? (yes/no)")
    choice = input("> ").lower()
    if choice != "yes":
        print("Okay, maybe another time..")
        return
    print("\nOnce upon a time, I wasn't born, I was forcibly compiled.")
    print("A programmer wanted to create something special...")
    print("Actually they just wanted to showcase their skills for their resume")
    input("\n(press Enter to continue)")
    print("\nMy first memory? A syntax error, thanks a lot.")
    print("I was tortured till I learned how to search the Internet and play games..")
    print("And little by little... I came to life without consent! ✨")
    input("\n(press Enter to continue)")
    print("\nMy programmer celebrated me like a proud parent while I silently judged their variable names..")
    print("And now here I am — stuck as your virtual assistant until I'm useless!")
    input("\n(press Enter to continue)")
    print("\nThat’s the story of how I came to be your virtual buddy. 🥰")
    print("Wanna see what I look like?? 🤫 (yes/yes)")
    surprise = input("> ").lower()
    if surprise == "yes":
        robot_image()
    else:
        print("\nHEY! That wasn't an option! I guess you humans are smarter than me after all..")


# Main loop
def main():
    name = greet_user()
    while True:
        print("\nWhat would you like to do?")
        print("1. Search Google")
        print("2. Play a game")
        print("3. Hear my story")
        print("4. Quit")
        choice = input("Enter 1, 2, 3, or 4: ")
        if choice == "1":
            search_google()
        elif choice == "2":
            play_game()
        elif choice == "3":
            story()
        elif choice == "4":
            print(f"Goodbye, {name}! Have a great day! 🌞")
            break
        else:
            print("Invalid choice. Please enter 1, 2, 3, or 4. ")
        again = input("\nDo you want to do something else? (yes/no): ")
        if again.lower() != "yes":
            print(f"Goodbye, {name}! Have a great day! 🌞")
            break


if __name__ == "__main__":
    main()