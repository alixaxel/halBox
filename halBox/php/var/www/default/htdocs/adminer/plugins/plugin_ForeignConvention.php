<?php

/** Link by FK Convention
* @author Alix Axel
* @license http://www.apache.org/licenses/LICENSE-2.0 Apache License, Version 2.0
*/
class AdminerForeignConvention {
    function foreignKeys($table) {
		$result = array();

		foreach (preg_grep('~^id_|_id$~', array_keys(fields($table))) as $field) {
			$result[] = array('table' => preg_replace('~^id_|_id$~', '', $field), 'source' => array($field), 'target' => array('id'));
		}

		return $result;
	}
}
