<?php

if (is_file('./adminer.php') === true)
{
	if ((is_dir('./plugins/') === true) && (is_file('./plugins/plugin.php') === true))
	{
		foreach (glob('./plugins/*.php') as $plugin)
		{
			include_once($plugin);
		}

		$plugins = array
		(
		);

		return new AdminerPlugin($plugins);
	}

	include_once('./adminer.php');
}

?>
