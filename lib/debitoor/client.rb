require "debitoor/version"
require "httparty"

module Debitoor
  class Client
    include HTTParty
    base_uri 'https://api.debitoor.com'

    def initialize(token)
      @token = token
      @options = { headers: {
        "x-token" => token,
        "Content-Type" => 'application/json'
      } }
    end

    # Public: Creates a draft invoice and accepts a body containing
    def create_draft_invoice(options={})
      options = options.merge!(@options)
      response = self.class.post("/api/sales/draftinvoices/v3?autonumber=true", options)
      respond_with!(response)
    end

    def get_last_invoice
      self.class.get("/api/sales/invoices/v3?limit=1", @options)
    end

    def book_draft_invoice(id_or_response_invoice)
      options = {
        query: {updateAutonumber: true, autonumbering: true, autonumber: true}
      }.merge!(@options)

      response = nil
      id = invoice_id(id_or_response_invoice)

      response = self.class.post("/api/sales/draftinvoices/#{id}/book/v3", options) if id.present?
      respond_with!(response)
    end

    def share_invoice(id_or_response_invoice, email, subject="Here's your receipt")
      options = {
        body: {recipient: email, subject: subject}.to_json
      }.merge!(@options)

      response = nil
      id = invoice_id(id_or_response_invoice)

      response = self.class.post("/api/sales/invoices/#{id}/share/v1", options) if id.present?
      respond_with!(response)
    end

    def email_invoice(id_or_response_invoice, email, subject="Here's your receipt", message="")
      options = {
        body: {recipient: email, subject: subject, message: message}.to_json
      }.merge!(@options)

      response = nil
      id = invoice_id(id_or_response_invoice)

      response = self.class.post("/api/sales/invoices/#{id}/email/v2", options) if id.present?
      respond_with!(response)
    end


    def get_products
      response = self.class.post("/api/products/v1", @options)
      respond_with!(response)
    end

    private

    def invoice_id(id_or_response_invoice)
      id = nil
      id = id_or_response_invoice if id_or_response_invoice.kind_of?(String)

      if (id_or_response_invoice.class == HTTParty::Response) && id_or_response_invoice.code.to_s.start_with?("2")
        id = id_or_response_invoice.parsed_response["id"]
      end

      return id
    end

    def respond_with!(response)
      raise(response.inspect) unless response.code.to_s.start_with?("2")
      return response
    end
  end

end
