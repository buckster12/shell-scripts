#!/bin/bash
# validint - проверяет целые числа, поддерживает отрицательные значения

validint() {
  number="$1"
  min="$2"
  max="$3"

  if [ -z "$number" ]; then
    echo "You didn't enter anything. Please, enter a number" >&2
    return 1
  fi

  # первый символ - минус?
  if [ "${number%${number#?}}" = "-" ]; then
    testvalue="${number#?}" # оставить для проверки все, кроме первого символа
  else
    testvalue="$number"
  fi

  # удалить все цифры из числа для проверки
  nodigits=${testvalue/[[:digit:]]/} # the same as the below command
  #  nodigits="$(echo $testvalue | sed 's/[[:digit:]]//g')"

  # проверить наличие нецифровых символов
  if [ -n "$nodigits" ]; then
    echo "Invalid number format! Only digits, no commas, spaces, etc." >&2
    return 1
  fi

  if [ -n "$min" ]; then
    # Входное значение меньше минимального?
    if [ "$number" -lt "$min" ]; then
      echo "Your value is too small: smallest acceptable value is $min." >&2
      return 1
    fi
  fi

  if [ -n "$max" ]; then
    # Входное значение больше максимального?
    if [ "$number" -gt "$max" ]; then
      echo "Your value is too big: largest acceptable value is $max." >&2
      return 1
    fi
  fi

  return 0
}

# Проверка ввода
if validint "$1" "$2" "$3"; then
  echo "Input is a valid integer within your constraints."
fi
