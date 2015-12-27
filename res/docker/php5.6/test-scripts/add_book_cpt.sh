#!/usr/bin/env bash

DOMAIN=$1
THEME=$2

cat << "EOF" >> /www/${DOMAIN}/wp-content/themes/${THEME}/functions.php
add_action( 'init', 'create_book_post_type' );
function create_book_post_type() {
    register_post_type( 'book',
        array(
            'labels' => array(
                'name' => __( 'Books', 'textdomain' ),
                'singular_name' => __( 'Book', 'textdomain' )
            ),
            'public' => true,
            'publicly_queryable' => true,
            'exclude_from_search' => false,
            'show_ui' => true,
            'show_in_menu' => true,
            'query_var' => true,
            'rewrite' => array('slug' => 'book'),
            'supports' =>array('title','editor', 'custom-fields','thumbnail')
        )
    );
}
EOF