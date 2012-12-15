<?php

if (is_file('./adminer.php') === true) {
	if ((is_dir('./plugins/') === true) && (is_file('./plugins/plugin.php') === true)) {
		function adminer_object() {
			include_once('./plugins/plugin.php');

			foreach (glob('./plugins/*.php') as $plugin) {
				include_once($plugin);
			}

			$plugins = array (
                new AdminerDatabaseHide(explode('|', 'information_schema|mysql|performance_schema')),
                new AdminerEditForeign(),
                new AdminerEnumOption(),
                new AdminerForeignConvention(),
			);

			return new AdminerPlugin($plugins);
		}
	}

	include_once('./adminer.php');
}
