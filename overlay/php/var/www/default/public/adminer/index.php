<?php

if (is_file('./adminer.php') === true) {
    if ((is_dir('./plugins/') === true) && (is_file('./plugins/plugin.php') === true)) {
        function adminer_object() {
            include_once('./plugins/plugin.php');

            foreach (glob('./plugins/*.php') as $plugin) {
                include_once($plugin);
            }

            $plugins = [
                new AdminerEditForeign(),
                new AdminerEnumOption(),
            ];

            return new AdminerPlugin($plugins);
        }
    }

    include_once('./adminer.php');
}
