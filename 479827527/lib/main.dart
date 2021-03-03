import 'package:flutter/material.dart';

List<int> splitIntoDigits({int number}) {
  List<int> listOfDigits;
  while (number > 0) {
    listOfDigits.add(number % 10);
    number ~/= 10;
  }
  return listOfDigits;
}

bool checkTicket({List<int> listOfDigits, int requiredSum}) {
  if (listOfDigits[0] + listOfDigits[1] + listOfDigits[2] ==
      listOfDigits[3] + listOfDigits[4] + listOfDigits[5] &&
      listOfDigits[3] + listOfDigits[4] + listOfDigits[5] == requiredSum) {
    return true;
  } else {
    return false;
  }
}

void main() {
  int minSearchValue = 100000;
  int maxSearchValue = 999999;

  int requiredSum = 1;
  int ticketsCounter = 0;
  List<int> listOfDigits;

  while (maxSearchValue >= minSearchValue) {
    listOfDigits = splitIntoDigits(number: minSearchValue);
    if (checkTicket(listOfDigits: listOfDigits, requiredSum: requiredSum)) {
      ticketsCounter++;
    }
    minSearchValue++;
  }
  print("Число билетов, у которых сумма первых трех элементов $requiredSum: $ticketsCounter");
}