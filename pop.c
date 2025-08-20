// 2024-11-20
// pop.c
// Farah Noor
// Vending Machine
// Purpose: To create a program which controls the operation of a soft drink vending machine.

#include <stdio.h>
#include <stdlib.h>
#define LOWEST_SELLINGPRICE 30
#define HIGHEST_SELLINGPRICE 115
#define MULTIPLE 5
#define COIN1_VALUE 5
#define COIN2_VALUE 10
#define COIN3_VALUE 20

void calculateChange(int amount, int *coin2, int *coin1)
{
  *coin2 = amount /  COIN2_VALUE;
  *coin1 = (amount% COIN2_VALUE) / COIN1_VALUE;
}


void customerMode(int selling_price)
{
  const char *message = "    Change given: %d centimes as %d dime(s) and %d nickel(s).\n";
  char coin;
  int price,  remaining_amount, inserted_amount, change, coin2, coin1;

  price = selling_price;
  remaining_amount = selling_price;
  inserted_amount = 0;

  printf("Pop is %d centimes. Please insert any combination of nickels [N or n], dimes [D or d] or Pentes [P or p]. You can also press R or r for coin return.\n", price);
  while (remaining_amount >  0)
{
    printf("Enter coin (NDPR): ");
    scanf(" %c", &coin);
    if (coin == 'n' || coin == 'N')
      {
        printf("  Nickel detected.\n");
        remaining_amount -= COIN1_VALUE;
        inserted_amount += COIN1_VALUE;
      }
    else if (coin == 'd' || coin == 'D')
      {
        printf("  Dime detected.\n");
        remaining_amount -=  COIN2_VALUE;
        inserted_amount +=  COIN2_VALUE;
      }
    else if (coin == 'p' || coin == 'P')
      {
        printf("  Pente detected.\n");
        remaining_amount -= COIN3_VALUE;
        inserted_amount += COIN3_VALUE;
      }
    else if (coin == 'r' || coin == 'R' || coin == 'k' || coin == 'K')
      {
        calculateChange(inserted_amount, &coin2, &coin1);
        printf(message, inserted_amount, coin2, coin1);
        if (coin == 'k' || coin == 'K')
        { 
          printf("Shutting down. Goodbye.\n");
          exit(1);
        }
        else
        {
        customerMode(selling_price);
        }
      }
    else
      {
        printf("Unknown coin rejected.\n");
      }
    printf("    You have inserted a total of %d centimes.\n", inserted_amount);
    if (remaining_amount > 0)
      {
        printf("    Please insert %d more centimes.\n", remaining_amount);
      }
    else
      {
        change = inserted_amount - price;
        calculateChange(change, &coin2, &coin1);
        printf("    Pop is dispensed. Thank you for your business! Please come again.\n");
        printf(message, change, coin2, coin1);
        customerMode(selling_price);
      }
  }
}


int main(int argc, char *argv[])
{
  int selling_price;
  if (argc != 2)
  {
    printf("Please specify the selling price as a command line argument.\nUsage: ./a.out [price]\n");
    return(0);
  }
  selling_price = atoi(argv[1]);
  if (selling_price < LOWEST_SELLINGPRICE || selling_price > HIGHEST_SELLINGPRICE)
  {
    printf("Price must be from %d to %d centimes inclusive.\n", LOWEST_SELLINGPRICE, HIGHEST_SELLINGPRICE);
    return(0);
  }
  else if (selling_price % MULTIPLE != 0)
  {
    printf("Price must be a multiple of %d.\n", MULTIPLE);
    return(0);
  }
  printf("Welcome to my C Pop Machine!\n");
  customerMode(selling_price);
  return (0);
}
