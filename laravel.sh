#!/bin/bash

SHOULD_DELETE=0
PROJECT_PATH="$HOME/Projects"
OTHER_ARGUMENTS=()

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -d|--delete)
        SHOULD_DELETE=1
        shift # Remove --delete from processing
        ;;
        -p=*|--path=*)
        PROJECT_PATH="${arg#*=}"
        shift # Remove --path= from processing
        ;;
        *)
        OTHER_ARGUMENTS+=("$1")
        shift # Remove generic argument from processing
        ;;
    esac
done


#Last argument is stored in PROJECT_NAME
for PROJECT_NAME in $OTHER_ARGUMENTS; do :; done

#if -d flag is set, then we delete the project and quit
if [ "$SHOULD_DELETE" == "1" ] ;then
    echo "🛑 Deleting the Project $PROJECT_PATH/$PROJECT_NAME"
    rm -rf "$PROJECT_PATH/$PROJECT_NAME"
    exit
fi

PROJECT_LOC="$PROJECT_PATH/$PROJECT_NAME"
echo "👉 Project Location -> $PROJECT_PATH"
echo "🚀 Creating Project -> $PROJECT_NAME "


echo "Do you want to proceed (y/n)?\c"
read answer

if [ "$answer" != "${answer#[Nn]}" ] ;then
    echo "🤝 Have a nice day!"
    exit
else
    echo "🍷 Buckle up........"
fi


echo "🙂 Installing the latest version of Laravel -> $PROJECT_NAME "
cd $PROJECT_PATH && laravel new $PROJECT_NAME
cd $PROJECT_LOC && composer require laravel-frontend-presets/tailwindcss --dev
cd $PROJECT_LOC && php artisan ui tailwindcss --auth

echo "🔭 Installing Telescope"
cd $PROJECT_LOC && composer require laravel/telescope --dev

echo "🔐 Installing Sanctum"
cd $PROJECT_LOC && composer require laravel/sanctum
cd $PROJECT_LOC && php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
cd $PROJECT_LOC && php artisan migrate


echo "😎 Installing Livewire"
cd $PROJECT_LOC && composer require livewire/livewire

echo "🚀 Installing Deployer"
cd $PROJECT_LOC && composer require lorisleiva/laravel-deployer --dev

echo "👨‍💻 Installing Debugbar & IDE Helper"
cd $PROJECT_LOC && composer require barryvdh/laravel-debugbar --dev
cd $PROJECT_LOC && composer require barryvdh/laravel-ide-helper --dev

echo "📦 Installing Spatie Packages"
cd $PROJECT_LOC && composer require spatie/laravel-permission
cd $PROJECT_LOC && composer require spatie/laravel-log-dumper

echo "💀 Brace yourself. Installing node packages with yarn."
cd $PROJECT_LOC && yarn
cd $PROJECT_LOC && yarn dev
