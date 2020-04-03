package model;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;

import org.deeplearning4j.nn.modelimport.keras.KerasModelImport;
import org.deeplearning4j.nn.modelimport.keras.exceptions.InvalidKerasConfigurationException;
import org.deeplearning4j.nn.modelimport.keras.exceptions.UnsupportedKerasConfigurationException;
import org.deeplearning4j.nn.multilayer.MultiLayerNetwork;
import org.nd4j.linalg.api.ndarray.INDArray;
import org.nd4j.linalg.factory.Nd4j;

public final class Patient {
	private int icustayId;
	private int sepsis;
	private double prediction;
	private double vitals[][];
	private static Connection conn;
	private static MultiLayerNetwork model;
	
	static {
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/mimic","postgres","postgres");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			model = KerasModelImport.importKerasSequentialModelAndWeights("/home/adarsh/eclipse-workspace/ldce/model/saved_model.h5");
		} catch (IOException | InvalidKerasConfigurationException | UnsupportedKerasConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public Patient(int icustayId) {
		super();
		this.icustayId = icustayId;
		this.vitals = new double[1][94];
		try {
			Statement stmt = conn.createStatement();
			ResultSet result = stmt.executeQuery("SELECT * FROM sepsis_dataset WHERE icustay_id = "+this.icustayId);
		
			while(result.next()) {
				this.sepsis = result.getInt("sepsis_explicit");
				System.out.println(this.sepsis);
				for(int i=0 ; i < this.vitals[0].length ; i++) {
					System.out.print(" "+result.getDouble(i+3));
					this.vitals[0][i] = result.getDouble(i+3);
				}
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	public int getIcustayId() {
		return icustayId;
	}
	public void setIcustayId(int icustayId) {
		this.icustayId = icustayId;
	}
	public int getSepsis() {
		return sepsis;
	}
	public void setSepsis(int sepsis) {
		this.sepsis = sepsis;
	}
	public double getPrediction() {
		return prediction;
	}
	public double calculatePrediction() {
		String simpleMlp = null;
		INDArray inputs = Nd4j.create(getVitals());
		this.prediction = model.output(inputs).getDouble(0);
		System.out.println(this.prediction);
		return this.prediction;
	}
	public double[][] getVitals() {
		return vitals;
	}
	public void setVitals(double[][] vitals) {
		this.vitals = vitals;
	}
	
	@Override
	public String toString() {
		return "Patient [icustayId=" + icustayId + ", sepsis=" + sepsis + ", prediction=" + prediction + ", vitals="
				+ Arrays.toString(vitals[0]) + "]";
		

	}
	public static void main(String[] args) {
		Patient p =new Patient(203111);
		p.calculatePrediction();
		System.out.println(p);
	}
	

}
