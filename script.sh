# First, delete all public posts
rm -rf public/posts/*

# Read all posts and generate a button for the index
POSTS_DATA=""
echo "Generating the INDEX"
for file in content/posts/*; do
    FILE_NAME=$(echo "$file" | sed 's|content/posts/||' | sed 's/.md//')
    TITLE=$(grep -m 1 "^title:" $file | sed "s/^title://" | sed "s/^ *//")
    DATE=$(grep -m 1 "^date:" $file | sed "s/^date://" | sed "s/^ *//")
    POST_DATA="<a href=\"/posts/$FILE_NAME\" class=\"post_data\"><div><h2>$TITLE</h2><p>$DATE</p></div></a>"
    POSTS_DATA="$POSTS_DATA$POST_DATA"
done

# Create the index.html in public
cp templates/index.html public/index.html
# Add the posts data (We use the | separator because there are / inside the variable)
sed -i -e "s|<div id=\"posts\">|<div id=\"posts\">$POSTS_DATA|" public/index.html

echo "Updating content/about.md"
# Create the about.html in public
pandoc \
    --standalone \
    --template templates/about.html \
    -o public/about/index.html \
    content/about.md

# Create the posts in public
for file in content/posts/*; do
    echo "Updating $file"
    FILE_NAME=$(echo "$file" | sed 's|content/posts/||' | sed 's/.md//')
    mkdir public/posts/$FILE_NAME
    pandoc \
        --standalone \
        --template templates/post.html \
        -o public/posts/$FILE_NAME/index.html \
        $file
done
