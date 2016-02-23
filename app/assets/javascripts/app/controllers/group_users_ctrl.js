angular.module('biomodelos').controller('group_users_ctrl', ['$scope', '$http', function($scope, $http ){
    $scope.my_var= "texto";

    $scope.msg_is_member = '';

    $scope.text_is_member = function(){

        switch ($scope.user_state){
            case 1:
                $scope.msg_is_member= "Abandonar Grupo";
                break;
            case 2:
                $scope.msg_is_member= "Pendiente de Aprobación";
                break;
            case 3:
                $scope.msg_is_member= "Solicitud Rechazada";
                break;
            case 4:
                $scope.msg_is_member= "Unirse al grupo";
                break;
            default:
                $scope.msg_is_member= "Unirse al grupo";
        }
    }

    $scope.unirse=function(group_id){
        if( !$scope.button_member) {
            $scope.button_member = true
            $http.post('/group_users', {group_id: group_id}).success(function (data) {
                $scope.is_member = data
                text_is_member();
                $scope.button_member = false
            }).error(function () {

            });
        }
    }

    $scope.approve_member=function(id){
        if(confirm("¿Desea aprobar al usuario?")){
            $http.post('/group_users/set_state', {id: id, state: 1}).success(function (data) {
                $scope.is_member[id] = true;
                $scope.was_rejected[id] = false;
            }).error(function () {
                alert("Ha ocurrido un error. El usuario no pudo ser aprobado.");
            });
        }
    }

    $scope.reject_member=function(id){
        if(confirm("¿Desea rechazar al usuario?")){
            $http.post('/group_users/set_state', {id: id, state: 3}).success(function (data) {
            $scope.is_member[id] = false;
            $scope.was_rejected[id] = true;
            }).error(function () {
                alert("Ha ocurrido un error. El usuario no pudo ser rechazado.");
            });
        }
    }

    $scope.approve_species=function(id){
        if(confirm("¿Desea aprobar la especie?")){
            $http.post('/species_groups/set_state', {id: id, state: 1}).success(function (data) {
            $scope.species_approved[id] = true;
            $scope.species_rejected[id] = false;
            }).error(function () {
                alert("Ha ocurrido un error. La especie no pudo ser aprobada.");
            });
        }
    }

    $scope.reject_species=function(id){
        if(confirm("¿Desea rechazar la especie?")){
            $http.post('/species_groups/set_state', {id: id, state: 3}).success(function (data) {
            $scope.species_approved[id] = false;
            $scope.species_rejected[id] = true;
            }).error(function () {
                alert("Ha ocurrido un error. La especie no pudo ser rechazada.");
            });
        }
    }
}
]);