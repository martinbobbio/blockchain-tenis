// SPDX-License-Identifier: MB
pragma solidity ^0.6.4;


contract TenisContract{
    //1, "Martin Bobbio", 23, "Zurdo", "Reves a dos manos"
    //2, "Toby Ferreira", 29, "Derecho", "Reves a una mano"

    //Estructura del objeto jugador
    struct playerInfo {
        string name;
        uint256 age;
        string skill_hand;
        string backhand_type;
        uint256 wins;
        uint256 loss;
        int256 points;
        uint256 aces;
        uint256 winners;
        uint256 double_fault;
        uint256 unforce_error;
    }
    //Mapping de jugadores
    mapping(uint256 => playerInfo) players;
    //Array de ids
    uint256[] private playersIds;
    //Validacion para saber si existe el id
    function checkIfIdExists(uint256 id) private view {
        for (uint i = 0; i < playersIds.length; i++) {
            if(playersIds[i] == id){
                revert("Id already exists, try with another id");
            }
        }
    }
    //Validacion para saber si no existe el id
    function checkIfIdNotExists(uint256 id) private view {
        for (uint i = 0; i < playersIds.length; i++) {
            if(playersIds[i] == id){
                return;
            }
        }
        revert("Id not exists, try with another id");
    }
    //Validacion para saber que son diferentes los id
    function checkIfIdsNotEquals(uint256 a, uint256 b) internal pure {
        if(a == b) revert("Ids are equals, try with others ids");
    }
    function calculatePoints(int256 a) internal pure returns (int256){
        return a / 10;
    }
    //Registro un jugador
    function registerPlayer(uint256 id, string memory name, uint256 age,
    string memory skill_hand, string memory backhand_type) public {
        checkIfIdExists(id);
        playerInfo storage newPlayer = players[id];
        newPlayer.name = name;
        newPlayer.age = age;
        newPlayer.backhand_type = backhand_type;
        newPlayer.skill_hand = skill_hand;
        newPlayer.wins = 0;
        newPlayer.loss = 0;
        newPlayer.points = 100;
        playersIds.push(id);
    }
    //Obtengo los datos de un jugador segun el id
    function getPlayerById(uint256 id) public view returns (string memory, uint256,
    string memory, string memory, uint256, uint256, int256, uint256, uint256, uint256, uint256){
        playerInfo storage s = players[id];
        return (s.name,s.age,s.skill_hand,s.backhand_type,s.wins,s.loss,s.points,s.aces,s.winners,s.double_fault,s.unforce_error);
    }
    //Creo un partido con metricas básicas
    function setMatchBasic(uint256 player_win_id, uint256 player_loss_id) public {
        checkIfIdNotExists(player_win_id);
        checkIfIdNotExists(player_loss_id);
        checkIfIdsNotEquals(player_win_id, player_loss_id);
        //Ganador
        players[player_win_id].wins += 1;
        players[player_win_id].points += calculatePoints(players[player_loss_id].points);
        //Perdedor
        players[player_loss_id].loss += 1;
        players[player_loss_id].points -= calculatePoints(players[player_loss_id].points);
    }
    //Creo un partido con metricas intermedias
    function setMatchIntermediate(uint256 player_win_id, uint256 player_win_aces,
    uint256 player_win_winners,uint256 player_loss_id, uint256 player_loss_aces,
    uint256 player_loss_winners) public {
        checkIfIdNotExists(player_win_id);
        checkIfIdNotExists(player_loss_id);
        checkIfIdsNotEquals(player_win_id, player_loss_id);
        //Ganador
        players[player_win_id].wins += 1;
        players[player_win_id].aces += player_win_aces;
        players[player_win_id].winners += player_win_winners;
        players[player_win_id].points += calculatePoints(players[player_loss_id].points);
        //Perdedor
        players[player_loss_id].loss += 1;
        players[player_loss_id].aces += player_loss_aces;
        players[player_loss_id].winners += player_loss_winners;
        players[player_loss_id].points -= calculatePoints(players[player_loss_id].points);
    }
    //Creo un partido con metricas avanzadas
    function setMatchAdvanced(uint256 player_win_id, uint256 player_win_aces,
    uint256 player_win_winners, uint256 player_win_double_faults, uint256 player_win_unforce_error,
    uint256 player_loss_id, uint256 player_loss_aces, uint256 player_loss_winners,
    uint256 player_loss_double_faults, uint256 player_loss_unforce_error) public {
        checkIfIdNotExists(player_win_id);
        checkIfIdNotExists(player_loss_id);
        checkIfIdsNotEquals(player_win_id, player_loss_id);
        //Ganador
        players[player_win_id].wins += 1;
        players[player_win_id].aces += player_win_aces;
        players[player_win_id].winners += player_win_winners;
        players[player_win_id].double_fault += player_win_double_faults;
        players[player_win_id].unforce_error += player_win_unforce_error;
        players[player_win_id].points += calculatePoints(players[player_loss_id].points);
        //Perdedor
        players[player_loss_id].loss += 1;
        players[player_loss_id].aces += player_loss_aces;
        players[player_loss_id].winners += player_loss_winners;
        players[player_loss_id].double_fault += player_loss_double_faults;
        players[player_loss_id].unforce_error += player_loss_unforce_error;
        players[player_loss_id].points -= calculatePoints(players[player_loss_id].points);
    }
    //Obtengo el total de jugadores
    function getPlayersLength() public view returns (uint256){
        return playersIds.length;
    }

}