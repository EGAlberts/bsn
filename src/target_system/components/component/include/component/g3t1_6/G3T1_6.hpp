#ifndef G3T1_6_HPP
#define G3T1_6_HPP

#include <string>
#include <exception>

#include "ros/ros.h"

#include "bsn/range/Range.hpp"
#include "bsn/resource/Battery.hpp"
#include "bsn/generator/Markov.hpp"
#include "bsn/generator/DataGenerator.hpp"
#include "bsn/filters/MovingAverage.hpp"
#include "bsn/utils/utils.hpp"
#include "bsn/configuration/SensorConfiguration.hpp"

#include "component/Sensor.hpp"

#include "messages/SensorData.h"
#include "services/PatientData.h"

class G3T1_6 : public Sensor {
    	
  	public:
    	G3T1_6(int &argc, char **argv, const std::string &name);
    	virtual ~G3T1_6();

	private:
      	G3T1_6(const G3T1_6 &);
    	G3T1_6 &operator=(const G3T1_6 &);

		std::string label(double &risk);
    
	public:
		virtual void setUp();
    	virtual void tearDown();

        double collect();
        double process(const double &data);
        void transfer(const double &data);

  	private:
		bsn::generator::Markov markov;
		bsn::generator::DataGenerator dataGenerator;		
		bsn::filters::MovingAverage filter;
		bsn::configuration::SensorConfiguration sensorConfig;

		ros::NodeHandle handle;
		ros::Publisher data_pub;
		ros::ServiceClient client;	

		double collected_risk;

};

#endif 
