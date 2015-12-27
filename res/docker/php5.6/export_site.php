<?php
$name            = $argv[1];
$file_base       = '/tmp/' . $argv[2];
$install_path    = $argv[3];
$sql_output_path = '/tmp/' . $name . '.sql';
$zip_output_path = '/tmp/' . $name . '.tar.gz';
exec( 'wp db export --allow-root --path=' . $install_path . ' ' . $sql_output_path );
exec( 'tar zcvf ' . $zip_output_path . ' ' . $install_path . ' --exclude-vcs' );
$zip = new ZipArchive();
$zip->open( $file_base, ZipArchive::CREATE | ZipArchive::OVERWRITE );
$zip->addFile( $sql_output_path, 'dump.sql' );
$zip->addFile( $zip_output_path, 'files.tar.gz' );
$zip->close();