<?php

/** Link by FK Convention
* @author Alix Axel
* @license http://www.apache.org/licenses/LICENSE-2.0 Apache License, Version 2.0
* @license http://www.gnu.org/licenses/gpl-2.0.html GNU General Public License, version 2 (one or other)
*/
class AdminerForeignConvention {
    function foreignKeys($table) {
		$result = array();

		foreach (fields($table) as $field) {
			if (preg_match('~^id_|_id$~', $field) > 0) {
				$result[] = array('table' => preg_replace('~^id_|_id$~', '', $field), 'source' => array($field), 'target' => array('id'));
			}
		}

		return $result;
	}
}
