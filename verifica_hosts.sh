
#!/bin/bash

cat /etc/hosts | while read -r ip nume rest
do
    if [ -z "$ip" ] || [ -z "$nume" ]; then
        continue
    fi

    case "$ip" in
        \#*|127.*|::*) continue ;;
        *:*) continue ;;
    esac

    adrese=$(nslookup -type=A "$nume" 2>/dev/null |
        awk '/^Name:/ {ok=1} ok && /^Address:/ {print $2}')

    if [ -z "$adrese" ]; then
        continue
    fi

    if ! echo "$adrese" | grep -Fxq "$ip"; then
        echo "Bogus IP for $nume in /etc/hosts!"
    fi
done

