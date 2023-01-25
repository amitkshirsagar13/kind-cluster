restart:
    bash restart-dev.sh

push MSG:
    git add . && git commit -m "{{MSG}}" && git push