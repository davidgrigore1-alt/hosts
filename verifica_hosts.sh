
#!/bin/bash

verifica_ip() {
    local nume="$1"
    local ip="$2"
    local dns="$3"

    local adrese

    adrese=$(nslookup -type=A "$nume" "$dns" 2>/dev/null |
        awk '/^Name:/ {ok=1} ok && /^Address:/ {print $2}')

    if [ -z "$adrese" ]; then
        return
    fi

    if ! echo "$adrese" | grep -Fxq "$ip"; then
        echo "Bogus IP for $nume in /etc/hosts!"
    fi
}

cat /etc/hosts | while read -r ip nume rest
do
    if [ -z "$ip" ] || [ -z "$nume" ]; then
        continue
    fi

    case "$ip" in
        \#*|127.*|::*) continue ;;
        *:*) continue ;;
    esac

    verifica_ip "$nume" "$ip" "8.8.8.8"
done
