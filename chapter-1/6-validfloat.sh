#!/bin/bash

. 5-validint.sh

validfloat() {
  fvalue="$1"

  # addon: check E numbers
  if [ "$(echo $fvalue | cut -de -f1 | cut -dE -f1)" != "$fvalue" ]; then

    # decimal part must be less than 10
    if [ "$(echo $fvalue | cut -d. -f1)" -lt 10 ]; then

      fullFranctionalPart="$(echo $fvalue | cut -d. -f2)"
      partBeforeE="$(echo $fullFranctionalPart | cut -de -f1 | cut -dE -f1)"
      powerOfE="$(echo $fvalue | cut -de -f2 | cut -dE -f2)"
      #      echo "partBeforeE ${partBeforeE}"
      #      echo "powerOfE ${powerOfE}"

      if validint $partBeforeE "" ""; then
        if validint $powerOfE "" ""; then
          echo "it is valid E number"
          return 1
        fi
      fi

    fi

  fi

  # check if point exists
  #  if [ -n "${fvalue/[^.]/}" ]; then
  if [ -n "$(echo $fvalue | sed 's/[^.]//g')" ]; then
    # extract main part of digit, on the left of point
    decimalPart="$(echo "$fvalue" | cut -d. -f1)"
    #    echo "decimalPart is $decimalPart"

    # extract float part of digit, on right of point
    fractionalPart="${fvalue#*\.}"
    #    fractionalPart="$(echo "$fvalue" | cut -d. -f2)" # THE SAME

    # check main part of digit, left side
    if [ -n "$decimalPart" ]; then
      if ! validint "$decimalPart" "" ""; then
        return 1
      fi
    fi

    # check float part
    # it cannot contain "-"
    if [ "${fractionalPart%${fractionalPart#?}}" = "-" ]; then
      echo "Invalid floating-point number: '-' not allowed after decimal point." >&2
      return 1
    fi
    if [ "$fractionalPart" != "" ]; then
      if ! validint "$fractionalPart" "0" ""; then
        return 1
      fi
    fi

  else
    # if all the digits is just "-"
    if [ "$fvalue" = "-" ]; then
      echo "Invalid floating-point format." >&2
      return 1
    fi

    # Finally, check the remaining numbers are valid
    if ! validint "$fvalue" "" ""; then
      return 1
    fi
  fi

  return 0
}

if validfloat "$1"; then
  echo "$1 is a valid floating-point value."
fi

exit 0
