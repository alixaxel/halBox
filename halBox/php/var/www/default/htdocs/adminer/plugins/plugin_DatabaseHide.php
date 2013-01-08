<?php

/** Hide Databases by Regex
* @author Alix Axel
* @license http://www.apache.org/licenses/LICENSE-2.0 Apache License, Version 2.0
*/
class AdminerDatabaseHide {
    protected $disabled;

	/**
	* @param array case insensitive database names in values
	*/
	function AdminerDatabaseHide($disabled) {
		$this->disabled = $disabled;
	}

	function databases($flush = true) {
        return preg_grep('~' . $this->disabled . '~i', get_databases($flush), PREG_GREP_INVERT);
	}
}
