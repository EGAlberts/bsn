bsn=$PWD/src/sa-bsn
exec_time=0

if [[ "$#" -ne 2 ]]; then
    echo "Invalid number of arguments! Please provide exactly 2 arguments."
    exit 1
fi

if [[ "$#" -eq 0 ]]; then
    exec_time=300
else
    exec_time=$1
fi

if [[ -n ${exec_time//[0-9]/} ]]; then
    echo "The execution time is not an integer!"
    exit 1
fi

xfce4-terminal -x roscore & sleep 5s

################# CONNECT ARDUINO #################
xfce4-terminal -x rosrun rosserial_python serial_node.py $2

################# KNOWLEDGE REPOSITORY #################
xfce4-terminal --working-directory=${bsn}/configurations/knowledge_repository -e 'roslaunch --pid=/var/tmp/data_access.pid data_access.launch' & sleep 1s

################# MANAGER SYSTEM #################
xfce4-terminal --working-directory=${bsn}/configurations/system_manager -e 'roslaunch --pid=/var/tmp/strategy_manager.pid strategy_manager.launch' & sleep 7s

xfce4-terminal --working-directory=${bsn}/configurations/system_manager -e 'roslaunch --pid=/var/tmp/strategy_enactor.pid strategy_enactor.launch' & sleep 1s

################# LOGGING INFRASTRUCTURE #################
xfce4-terminal --working-directory=${bsn}/configurations/logging_infrastructure -e 'roslaunch --pid=/var/tmp/logger.pid logger.launch' & sleep 1s

################# APPLICATION #################
xfce4-terminal --working-directory=${bsn}/configurations/target_system -e 'roslaunch --pid=/var/tmp/probe.pid probe.launch' & sleep 1s
xfce4-terminal --working-directory=${bsn}/configurations/target_system -e 'roslaunch --pid=/var/tmp/effector.pid effector.launch' & sleep 1s

xfce4-terminal --working-directory=${bsn}/configurations/target_system -e 'roslaunch --pid=/var/tmp/g4t1.pid g4t1.launch'
xfce4-terminal --working-directory=${bsn}/configurations/environment   -e 'roslaunch --pid=/var/tmp/patient.pid patient.launch' & sleep 5s

xfce4-terminal --working-directory=${bsn}/configurations/target_system -e 'roslaunch --pid=/var/tmp/g3t1_1.pid real_sensor_g3t1_1.launch' & sleep 2s
xfce4-terminal --working-directory=${bsn}/configurations/target_system -e 'roslaunch --pid=/var/tmp/g3t1_2.pid real_sensor_g3t1_2.launch' & sleep 2s
xfce4-terminal --working-directory=${bsn}/configurations/target_system -e 'roslaunch --pid=/var/tmp/g3t1_3.pid real_sensor_g3t1_3.launch' & sleep 2s

################# SIMULATION #################
sleep ${exec_time}s

kill $(cat /var/tmp/data_access.pid && rm /var/tmp/data_access.pid) & sleep 1s
kill $(cat /var/tmp/strategy_enactor.pid && rm /var/tmp/strategy_enactor.pid) & sleep 1s
kill $(cat /var/tmp/logger.pid && rm /var/tmp/logger.pid) & sleep 1s
kill $(cat /var/tmp/probe.pid && rm /var/tmp/probe.pid) & sleep 1s
kill $(cat /var/tmp/effector.pid && rm /var/tmp/effector.pid) & sleep 1s
kill $(cat /var/tmp/g4t1.pid && rm /var/tmp/g4t1.pid) & sleep 1s
kill $(cat /var/tmp/g3t1_1.pid && rm /var/tmp/g3t1_1.pid) & sleep 1s
kill $(cat /var/tmp/g3t1_2.pid && rm /var/tmp/g3t1_2.pid) & sleep 1s
kill $(cat /var/tmp/g3t1_3.pid && rm /var/tmp/g3t1_3.pid) & sleep 1s
kill $(cat /var/tmp/patient.pid && rm /var/tmp/patient.pid) & sleep 1s
kill $(cat /var/tmp/strategy_manager.pid && rm /var/tmp/strategy_manager.pid) & sleep 1s

rosnode kill -a
kill $(pgrep roscore)