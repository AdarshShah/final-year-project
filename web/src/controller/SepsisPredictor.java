package controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Patient;

/**
 * Servlet implementation class SepsisPredictor
 */
@WebServlet("/SepsisPredictor")
public final class SepsisPredictor extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SepsisPredictor() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int icustayId = Integer.parseInt(request.getParameter("icustayId"));
		Patient p = new Patient(icustayId);
		double result = p.getPrediction();
		int sepsis = p.getSepsis();
		PrintWriter writer = response.getWriter();
		writer.write("Sepsis : "+sepsis+" Prediction : "+result);
	}

}
